usingnamespace @import("std").builtin;
/// Deprecated
pub const arch = Target.current.cpu.arch;
/// Deprecated
pub const endian = Target.current.cpu.arch.endian();
pub const output_mode = OutputMode.Exe;
pub const link_mode = LinkMode.Static;
pub const is_test = true;
pub const single_threaded = false;
pub const abi = Abi.msvc;
pub const cpu: Cpu = Cpu{
    .arch = .x86_64,
    .model = &Target.x86.cpu.znver2,
    .features = Target.x86.featureSet(&[_]Target.x86.Feature{
        .@"64bit",
        .@"adx",
        .@"aes",
        .@"avx",
        .@"avx2",
        .@"bmi",
        .@"bmi2",
        .@"branchfusion",
        .@"clflushopt",
        .@"clwb",
        .@"clzero",
        .@"cmov",
        .@"cx16",
        .@"cx8",
        .@"f16c",
        .@"fast_15bytenop",
        .@"fast_bextr",
        .@"fast_lzcnt",
        .@"fast_scalar_shift_masks",
        .@"fma",
        .@"fsgsbase",
        .@"fxsr",
        .@"lzcnt",
        .@"mmx",
        .@"movbe",
        .@"nopl",
        .@"pclmul",
        .@"popcnt",
        .@"prfchw",
        .@"rdpid",
        .@"rdrnd",
        .@"rdseed",
        .@"sahf",
        .@"sha",
        .@"slow_shld",
        .@"sse",
        .@"sse2",
        .@"sse3",
        .@"sse4_1",
        .@"sse4_2",
        .@"sse4a",
        .@"ssse3",
        .@"vzeroupper",
        .@"x87",
        .@"xsave",
        .@"xsavec",
        .@"xsaveopt",
        .@"xsaves",
    }),
};
pub const os = Os{
    .tag = .windows,
    .version_range = .{ .windows = .{
        .min = .win10_20h1,
        .max = .win10_20h1,
    }},
};
pub const object_format = ObjectFormat.coff;
pub const mode = Mode.Debug;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = true;
pub const valgrind_support = false;
pub const position_independent_code = true;
pub const strip_debug_info = false;
pub const code_model = CodeModel.default;
pub var test_functions: []TestFn = undefined; // overwritten later
pub const test_io_mode = .blocking;