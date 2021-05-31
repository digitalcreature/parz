const std = @import("std");
usingnamespace @import("source.zig");

pub const Operator = enum(u8) {
    add = '+',
    sub = '-',
    mul = '*',
    div = '/',
};

pub const Paren = enum(u8) {
    open = '(',
    close = ')',
};

pub const Token = union(enum) {
    digits: []const u8,
    operator: Operator,
    paren: Paren,


    pub fn format(self: Token, comptime fmt: []const u8, options: std.fmt.FormatOptions, stream: anytype) !void {
        try stream.writeAll("[ ");
        try stream.writeAll(@tagName(self));
        try stream.writeAll(": ");
        switch (self) {
            .digits => |digits| try stream.print("{s}", .{digits}),
            .operator => |operator| try stream.print("'{c}'", .{@enumToInt(operator)}),
            .paren => |paren| try stream.print("'{c}'", .{@enumToInt(paren)}),
        }
        try stream.writeAll(" ]");
    }

};

pub const LexError = error {
    EndOfFile,
    InvalidToken,
};

pub const Lexer = struct {

    cursor: Cursor,

    const Self = @This();

    pub fn init(cursor: Cursor) Self {
        return Self{
            .cursor = cursor,
        };
    }

    pub fn whitespace(self: *Self) void {
        while (!self.cursor.isAtEndOfFile()) {
            const next_opt = self.cursor.next();
            if (next_opt) |next| {
                if (std.ascii.isSpace(next)) {
                    continue;
                }
            }
            return;
        }
    }

    pub fn digits(self: *Self) LexError![]const u8 {
        const start = self.cursor.lookahead.ptr;
        var count: usize = 0;
        while (!self.cursor.isAtEndOfFile()) {
            const next_opt = self.cursor.next();
            if (next_opt) |next| {
                if (std.ascii.isDigit(next)) {
                    count += 1;
                    continue;
                }
            }
            break;
        }
        if (count > 0) {
            return start[0..count];
        }
        else {
            return LexError.InvalidToken;
        }
    }

    pub fn nextToken(self: *Self) LexError!Token {
        self.whitespace();
        if (self.cursor.isAtEndOfFile()) {
            return LexError.EndOfFile;
        }
        const cursor = self.cursor;
        const next_opt = self.cursor.next();
        if (next_opt) |next| {
            switch (next) {
                '+', '-', '*', '/' => |operator| {
                    return Token{ .operator = @intToEnum(Operator, operator)};
                },
                '(', ')' => |paren| {
                    return Token{ .paren = @intToEnum(Paren, paren) };
                },
                else => {
                    self.cursor = cursor;
                    return Token{ .digits = try self.digits() };
                },
            }
        }
        else {
            return LexError.EndOfFile;
        }
    }

};

test "lexer" {
    const src = "1 + (2 - 3)";
    var lexer = Lexer.init(Cursor.init(.{ .text = src, }));
    std.testing.log_level = .debug;
    std.log.debug("lexing...", .{});
    while (lexer.nextToken()) |token| {
        std.log.debug("{}", .{token});
    }
    else |err| {
        std.log.err("{s}", .{@errorName(err)});
    }
}