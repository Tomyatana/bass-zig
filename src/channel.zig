const c = @cImport({
    @cInclude("bass.h");
});

const errors = @import("errors.zig");
const BassError = errors.BassError;

pub const ChannelHandle = struct {
    handle: u32,

    const Self = @This();

    pub fn Play(self: Self, restart: bool) BassError!void {
        const res = c.BASS_ChannelPlay(self.handle, @intFromBool(restart));
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn Activity(self: Self) ChannelActivity {
        const ret = c.BASS_ChannelIsActive(self.handle);
        return @enumFromInt(ret);
    }
};

pub const ChannelActivity = enum(u32) {
    Stopped = c.BASS_ACTIVE_STOPPED,
    Playing = c.BASS_ACTIVE_PLAYING,
    Paused = c.BASS_ACTIVE_PAUSED,
    PausedDevice = c.BASS_ACTIVE_PAUSED_DEVICE,
    Stalled = c.BASS_ACTIVE_STALLED,
};
