pub const Frame = @import("frame.zig").Frame;
pub const Server = @import("Server.zig");

test "Echo server" {
    const std = @import("std");

    const allocator = std.testing.allocator;

    var server = try Server.init();
    defer server.deinit();

    try server.bind(8932);

    var frame = Frame(Server).init(server);

    while (true) {
        const packet = try frame.readPacket(allocator) orelse continue;

        defer allocator.free(packet);

        std.debug.print("{s}\n", .{packet});

        break;
    }
}
