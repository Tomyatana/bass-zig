const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const src_path = b.path("src/bass.zig").src_path;
    _ = b.addModule("bass-zig", .{
        .link_libc = true,
        .root_source_file = .{ .src_path = src_path },
        .optimize = optimize,
        .target = target,
    });

    const lib = b.addStaticLibrary(.{
        .name = "bass",
        .root_source_file = .{ .src_path = src_path },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    lib.linkSystemLibrary2("bass", .{ .needed = true });

    b.installArtifact(lib);
}
