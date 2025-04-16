const std = @import("std");
const Self = @This();

const DEFAULT_HOST = "0.0.0.0";

socket: std.posix.socket_t,

pub fn init() !Self {
    const sock = try std.posix.socket(
        std.posix.AF.INET,
        std.posix.SOCK.DGRAM | std.posix.SOCK.NONBLOCK,
        std.posix.IPPROTO.UDP,
    );

    return Self{
        .socket = sock,
    };
}

pub fn bind(self: *Self, port: u16) !void {
    const addr = try std.net.Address.parseIp(DEFAULT_HOST, port);

    try std.posix.bind(self.socket, &addr.any, addr.getOsSockLen());
}

pub fn read(self: *Self, buf: []u8) !?usize {
    const result = std.posix.recvfrom(
        self.socket,
        buf,
        0,
        null,
        null,
    ) catch |err| {
        if (err == std.posix.RecvFromError.WouldBlock) {
            return null;
        } else {
            return err;
        }
    };

    return result;
}

pub fn deinit(self: *Self) void {
    std.posix.close(self.socket);
}
