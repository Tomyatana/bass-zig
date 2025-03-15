const c = @cImport({
    @cInclude("bass.h");
});

const errors = @import("errors.zig");
const channel = @import("channel.zig");

const BassError = errors.BassError;

pub const SampleHandle = struct {
    handle: u32,

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
};

/// fix `file` type
pub fn Load(mem: bool, file: ?*const anyopaque, offset: u32, length: u32, max: u32, flags: u32) BassError!SampleHandle {
    const res = c.BASS_SampleLoad(@intFromBool(mem), file, offset, length, max, flags);
    if (res == 0) {
        return errors.getError();
    }
    return SampleHandle{
        .handle = res,
    };
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
