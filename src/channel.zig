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

    pub fn Start(self: Self) BassError!void {
        const res = c.BASS_ChannelStart(self.handle);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn Pause(self: Self) BassError!void {
        const res = c.BASS_ChannelPause(self.handle);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn Stop(self: Self) BassError!void {
        const res = c.BASS_ChannelStop(self.handle);
        if (res != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn Activity(self: Self) ChannelActivity {
        const ret = c.BASS_ChannelIsActive(self.handle);
        return @enumFromInt(ret);
    }

    pub fn GetAttribute(self: Self, attr: ChannelAttribute) !f32 {
        var retVal: f32 = 0;
        const ret = c.BASS_ChannelGetAttribute(self.handle, @intFromEnum(attr), &retVal);
        if (ret != c.TRUE) {
            return errors.getError();
        }
        return retVal;
    }

    pub fn SetAttribute(self: Self, attr: ChannelAttribute, val: f32) !void {
        const ret = c.BASS_ChannelSetAttribute(self.handle, @intFromEnum(attr), val);
        if (ret != c.TRUE) {
            return errors.getError();
        }
    }

    pub fn GetDevice(self: Self) !u32 {
        const ret = c.BASS_ChannelGetDevice(self.handle);
        if (ret == -1) {
            return errors.getError();
        }
        return ret;
    }

    pub fn Free(self: *Self) !void {
        const ret = c.BASS_ChannelFree(self.handle);
        if (ret != c.TRUE) {
            return errors.getError();
        }
        self.handle = 0;
        return;
    }
};

pub const ChannelActivity = enum(u32) {
    Stopped = c.BASS_ACTIVE_STOPPED,
    Playing = c.BASS_ACTIVE_PLAYING,
    Paused = c.BASS_ACTIVE_PAUSED,
    PausedDevice = c.BASS_ACTIVE_PAUSED_DEVICE,
    Stalled = c.BASS_ACTIVE_STALLED,
};

pub const ChannelAttribute = enum(u32) {
    /// stream
    Bitrate = c.BASS_ATTRIB_BITRATE,
    /// stream/music
    BufLen = c.BASS_ATTRIB_BUFFER,
    /// stream/music
    CpuUsage = c.BASS_ATTRIB_CPU,
    DownloadProc = c.BASS_ATTRIB_DOWNLOADPROC,
    Frequency = c.BASS_ATTRIB_FREQ,
    /// stream/music/record
    Granule = c.BASS_ATTRIB_GRANULE,
    /// music
    MusicActive = c.BASS_ATTRIB_MUSIC_ACTIVE,
    /// music
    MusicAmplify = c.BASS_ATTRIB_MUSIC_AMPLIFY,
    /// music
    MusicBpm = c.BASS_ATTRIB_MUSIC_BPM,
    /// music
    MusicPanSep = c.BASS_ATTRIB_MUSIC_PANSEP,
    /// music
    MusicPosScaler = c.BASS_ATTRIB_MUSIC_PSCALER,
    /// music
    MusicSpeed = c.BASS_ATTRIB_MUSIC_SPEED,
    /// music
    MusicChannelVol = c.BASS_ATTRIB_MUSIC_VOL_CHAN,
    /// music
    MusicGlobalVol = c.BASS_ATTRIB_MUSIC_VOL_GLOBAL,
    /// music
    MusicInstVol = c.BASS_ATTRIB_MUSIC_VOL_INST,
    /// stream
    NetResume = c.BASS_ATTRIB_NET_RESUME,
    Ramping = c.BASS_ATTRIB_NORAMP,
    Panning = c.BASS_ATTRIB_PAN,
    PushLimit = c.BASS_ATTRIB_PUSH_LIMIT,
    ScanInfo = c.BASS_ATTRIB_SCANINFO,
    SampleRateConv = c.BASS_ATTRIB_SRC,
    /// music/stream
    Tail = c.BASS_ATTRIB_TAIL,
    UserInfo = c.BASS_ATTRIB_USER,
    Volume = c.BASS_ATTRIB_VOL,
    /// music/stream/record
    DspChainVolume = c.BASS_ATTRIB_VOLDSP,
    DspVolPriority = c.BASS_ATTRIB_VOLDSP_PRIORITY,
};
