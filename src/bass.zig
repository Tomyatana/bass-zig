const std = @import("std");
const errors = @import("errors.zig");
const c = @cImport({
    @cInclude("bass.h");
});

pub const sample = @import("sample.zig");
pub const channel = @import("channel.zig");
pub const plugins = @import("plugins.zig");

pub const BassError = errors.BassError;
pub const getError = errors.getError;

/// If `device` == `null` uses default from the system
pub fn Init(device: ?i32, freq: u32, flags: InitFlags, win: ?*anyopaque) BassError!void {
    const dev = device orelse -1;
    const res = c.BASS_Init(dev, freq, @bitCast(flags), win, null);
    if (res == c.FALSE) {
        return getError();
    }
}

pub fn Stop() !void {
    const res = c.BASS_Stop();
    if (res == c.FALSE) {
        return getError();
    }
}

pub fn Free() !void {
    const res = c.BASS_Stop();
    if (res == c.FALSE) {
        return getError();
    }
}

pub fn isStarted() BassStatus {
    return @enumFromInt(c.BASS_IsStarted());
}

pub const BassStatus = enum(u32) {
    NotStarted = 0,
    Started = 1,
    Active = 2,
};

pub const InitFlags = packed struct(u32) {
    dev8bit: bool = false,
    mono: bool = false,
    dev3d: bool = false,
    dev16bit: bool = false,
    __unused: u3 = 0,
    reinit: bool = false,
    /// unused
    latency: bool = false,
    __unused1: bool = false,
    /// unused
    cpspeakers: bool = false,
    speakers: bool = false,
    __unused2: bool = false,
    nospeaker: bool = false,
    dmix: bool = false,
    freq: bool = false,
    stereo: bool = false,
    hog: bool = false,
    audiotrack: bool = false,
    dsound: bool = false,
    software: bool = false,
    __unused3: u11 = 0,
};
