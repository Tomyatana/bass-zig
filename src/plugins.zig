const c = @cImport({
    @cInclude("bass.h");
});

const errors = @import("errors.zig");
const getError = errors.getError;

pub fn load(file: [*:0]u8, flags: u32) !PluginHandle { // Add flags later
    const res = c.BASS_PluginLoad(file, flags);
    if (res == c.FALSE) {
        return getError();
    }
    return PluginHandle{
        .handle = res,
    };
}

const PluginFlags = enum(u32) {
    Unicode = c.BASS_UNICODE,
    PluginProc = c.BASS_PLUGIN_PROC,
};

pub const PluginHandle = struct {
    handle: u32,
    const Self = @This();

    pub fn Free(self: *Self) !void {
        const res = c.BASS_PluginFree(self.handle);
        if (res == c.FALSE) {
            return getError();
        }
        self.handle = 0;
    }

    pub fn Enable(self: Self, enable: bool) !void {
        const res = c.BASS_PluginEnable(self.handle, @intFromBool(enable));
        if (res == c.FALSE) {
            return getError();
        }
    }
};
