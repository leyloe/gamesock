const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("gamesock", .{
        .root_source_file = b.path("src/root.zig"),
    });

    const test_step = b.step("test", "Run library tests");
    const tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
    });

    test_step.dependOn(&b.addRunArtifact(tests).step);
}
