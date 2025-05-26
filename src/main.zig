const std = @import("std");
const print = std.debug.print;

var total: u32 = 0;

const total_spaces = 16;
const TsType = u16;

pub fn main() !void {
    var timer = try std.time.Timer.start();
    var stdout = std.io.getStdOut().writer();
    var curr_placement: TsType = 1;
    inline for (0..(total_spaces / 2)) |_| {
        place_queen(curr_placement, curr_placement, curr_placement, 0);
        curr_placement = curr_placement << 1;
    }
    total *= 2;
    const stop = timer.read();
    try stdout.print("\n\ntotal: {d}\nin\n{d} ns\n{d} us\n{d} ms\n{d} secs\n", .{ total, stop, stop / std.time.ns_per_us, stop / std.time.ns_per_ms, stop / std.time.ns_per_s });
}

fn place_queen(prev_left_diagonal: TsType, prev_right_diagonal: TsType, prev_x: TsType, comptime prev_y: TsType) void {
    const left_diagonal = prev_left_diagonal << 1;
    const right_diagonal = prev_right_diagonal >> 1;
    const curr_no_goes = left_diagonal | right_diagonal | prev_x;
    if (prev_y > (total_spaces / 2) and curr_no_goes == std.math.maxInt(TsType)) return;

    var curr_placement: TsType = 1;

    inline for (0..total_spaces) |_| {
        defer curr_placement <<= 1;
        const new_set = curr_no_goes | curr_placement;
        if (new_set != curr_no_goes) {
            if (prev_y == (total_spaces - 2)) {
                total += 1;
            } else {
                place_queen(left_diagonal | curr_placement, right_diagonal | curr_placement, prev_x | curr_placement, prev_y + 1);
            }
        }
    }
}
