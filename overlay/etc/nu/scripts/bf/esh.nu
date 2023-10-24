use env.nu
use fs.nu
use write.nu

# Generate output using input as an esh template
export def main [
    input: string   # input file
    output: string  # output file
] {
    # ensure template file exists
    if ($input | fs is_not_file) { write error $"Template file ($input) does not exist." esh }

    # generate output file and display any errors
    let result = do { ^esh -o $output $input } | complete
    if ($result.exit_code == 0) and ($output | path exists) {
        write debug $"($output) created." esh
    } else {
        write error $"Error using template: ($result.stderr)." esh
    }
}

export def template [
    filename: string
    output_dir: string
] {
    # build paths and ensure input file and output directory exist
    let input = $"(env ETC_TEMPLATES)/($filename).esh"
    let output = $"($output_dir)/($filename)"
    if ($input | fs is_not_file) { write error $"Template ($input) does not exist." esh/template }
    if ($output_dir | fs is_not_dir) { write error $"Output directory ($output_dir) does not exist." esh/template }

    # output debug message and generate file
    write debug $" .. ($filename)"
    main $input $output
}
