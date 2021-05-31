const std = @import("std");

const SourceError = error {
    EndOfFile,
};

pub const Source = struct {

    name: []const u8 = "<embed>",
    text: []const u8,

};

pub const Cursor = struct {
    
    source: Source,
    lookahead: []const u8,
    line_number: usize = 1,
    col_number: usize = 1,
    position: usize = 0,

    const Self = @This();

    pub fn init(source: Source) Self {
        return .{
            .source = source,
            .lookahead = source.text,
        };
    }

    pub fn next(self: *Self) ?u8 {
        if (self.isAtEndOfFile()) {
            return null;
        }
        const char = self.lookahead[0];
        std.log.debug("'{c}'", .{char});
        self.position += 1;
        self.lookahead = self.lookahead[1..];
        if (char == '\n') {
            self.line_number += 1;
            self.col_number = 1;
        }
        else {
            self.col_number += 1;
        }
        if (self.lookahead.len == 0) {
            return null;
        }
        else {
            return char;
        }
    }

    pub fn isAtEndOfFile(self: Self) bool {
        return self.lookahead.len == 0;
    }


};