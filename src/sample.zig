const c = @cImport({
    @cInclude("bass.h");
});
const std = @import("std");

const errors = @import("errors.zig");
const channel = @import("channel.zig");

const BassError = errors.BassError;

pub const SampleHandle = struct {
    handle: u32,
    info: SampleInfo = undefined,

    const Self = @This();

    pub fn getChannel(self: Self, flags: u32) !channel.ChannelHandle { // add flags later
        const res = c.BASS_SampleGetChannel(self.handle, flags);
        if (res == 0) {
            return errors.getError();
        }
        return channel.ChannelHandle{ .handle = res };
    }

    pub fn Free(self: *Self) !void {
        const res = c.BASS_SampleFree(self.handle);
        if (res == c.FALSE) {
            return errors.getError();
        }
        self.handle = 0;
    }

    pub fn GetData(self: Self, buf: ?*anyopaque) !void {
        const res = c.BASS_SampleGetData(self.handle, buf);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn GetDataAlloc(self: Self, allocator: std.mem.Allocator) ![*]u8 {
        var out = try allocator.alloc(u8, self.info.length);
        const res = c.BASS_SampleGetData(self.handle, &out);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn SetData(self: Self, data: ?[*]u8) !void {
        const res = c.BASS_SampleSetData(self.handle, data);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn GetInfo(self: *Self) !void {
        var sample: c.BASS_SAMPLE = .{};
        const res = c.BASS_SampleGetInfo(self.handle, &sample);
        if (res != c.TRUE) {
            return errors.getError();
        }
        self.info = .{
            .freq = sample.freq,
            .volume = sample.volume,
            .panning = sample.pan,
            .flags = sample.flags,
            .length = sample.length,
            .max = sample.max,
            .original_res = sample.origres,
            .channels = sample.chans,
            .mingap = sample.mingap,
            .info3d = .{
                .mode3d = sample.mode3d,
                .mindist = sample.mindist,
                .maxdist = sample.maxdist,
                .iangle = sample.iangle,
                .oangle = sample.oangle,
                .outvol = sample.outvol,
                .vam = sample.vam,
                .priority = sample.priority,
            },
        };
    }
};

const SampleInfo = struct {
    freq: u32 = 0,
    volume: f32 = 0,
    panning: f32 = 0,
    /// Add packed struct
    flags: u32 = 0,
    length: u32 = 0,
    max: u32 = 0,
    original_res: u32 = 0,
    channels: u32 = 0,
    mingap: u32 = 0,
    info3d: struct {
        mode3d: u32 = 0,
        mindist: f32 = 0,
        maxdist: f32 = 0,
        iangle: u32 = 0,
        oangle: u32 = 0,
        outvol: f32 = 0,
        vam: u32 = 0,
        priority: u32 = 0,
    },
};

pub fn Load(mem: bool, file: ?*const anyopaque, offset: u32, length: u32, max: u32, flags: u32) BassError!SampleHandle {
    if (max < 1) return errors.BassError.IllParamError;
    const res = c.BASS_SampleLoad(@intFromBool(mem), file, offset, length, max, flags);
    if (res == 0) {
        return errors.getError();
    }
    var sample = SampleHandle{
        .handle = res,
    };
    try sample.GetInfo();
    return sample;
}

pub fn Create(len: u32, freq: u32, channels: u32, max: u32, flags: u32) BassError!SampleHandle {
    if (max < 1) return errors.BassError.IllParamError;
    const res = c.BASS_SampleCreate(len, freq, channels, max, flags);
    if (res == 0) {
        return errors.getError();
    }
    var sample = SampleHandle{
        .handle = res,
    };
    try sample.GetInfo();
    return sample;
}

pub const SampleFlags = enum(u32) {
    None = 0,
    Float = c.BASS_SAMPLE_FLOAT,
    Loop = c.BASS_SAMPLE_LOOP,
    Mono = c.BASS_SAMPLE_MONO,
    Sample3D = c.BASS_SAMPLE_3D,
    MuteMax = c.BASS_SAMPLE_MUTEMAX,
    OverVol = c.BASS_SAMPLE_OVER_VOL,
    OverPos = c.BASS_SAMPLE_OVER_POS,
    OverDist = c.BASS_SAMPLE_OVER_DIST,
    Unicode = c.BASS_UNICODE,
};
