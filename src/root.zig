const Frame = @import("frame.zig").Frame;
const Server = @import("Server.zig");

test "Echo server" {
    const std = @import("std");

    const allocator = std.testing.allocator;

    var server = try Server.init();
    defer server.deinit();

    try server.bind(8932);

    var frame = Frame(Server).init(server);

    while (true) {
        const result = try frame.readPacket(allocator);

        const packet = result orelse continue;
        defer allocator.free(packet);

        std.debug.print("{s}\n", .{packet});

        break;
    }
}
