const std = @import("std");

const HEADER_SIZE = 4;

pub fn Frame(comptime S: type) type {
    return struct {
        const Self = @This();

        inner: S,

        pub fn init(stream: S) Self {
            return Self{ .inner = stream };
        }

        pub fn writePacket(self: *Self, allocator: std.mem.Allocator, buffer: []const u8) !void {
            const len: u32 = @intCast(buffer.len);
            var len_bytes: [HEADER_SIZE]u8 = undefined;

            std.mem.writeInt(u32, &len_bytes, len, .big);

            var buf = std.ArrayList(u8).init(allocator);
            defer buf.deinit();

            try buf.appendSlice(len_bytes[0..HEADER_SIZE]);
            try buf.appendSlice(buffer[0..buffer.len]);

            const bytes_written = try self.inner.write(buf.items);
            if (bytes_written != buf.items.len) {
                return error.WriteError;
            }
        }

        pub fn readPacket(self: *Self, buf: []u8) !void {
            var len: [4]u8 = undefined;

            var bytes_read = try self.inner.read(len[0..HEADER_SIZE]);
            if (bytes_read != HEADER_SIZE) {
                return error.ReadError;
            }

            const packet_len = std.mem.readInt(u32, &len, .big);

            bytes_read = try self.inner.read(buf[0..packet_len]);
            if (bytes_read != packet_len) {
                return error.ReadError;
            }
        }
    };
}
