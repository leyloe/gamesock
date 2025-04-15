const Frame = @import("frame.zig").Frame;

test "Write Test" {
    const std = @import("std");

    const allocator = std.testing.allocator;
    const stream = std.io.getStdOut();
    var frame = Frame(std.fs.File).init(stream);

    const data = "Hello, World!\n";
    try frame.writePacket(allocator, data);
}
