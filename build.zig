const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bass_zig = b.addModule("bass-zig", .{
        .root_source_file = b.path("src/bass.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    bass_zig.linkSystemLibrary("bass", .{ .needed = true });
}
