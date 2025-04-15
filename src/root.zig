const Frame = @import("frame.zig").Frame;

test "Write Test" {
    const std = @import("std");

    const allocator = std.testing.allocator;

    const file = try std.fs.cwd().createFile("test_write.bin", .{ .read = true });
    defer file.close();

    var frame = Frame(std.fs.File).init(file);

    const data = "\x33\x44\x55\x66\x77\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF";

    try frame.writePacket(allocator, data);

    try file.seekTo(0);

    const bytes = try frame.readPacket(allocator);
    defer allocator.free(bytes);

    std.debug.print("{d}", .{bytes});
}
