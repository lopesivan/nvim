return {
    tasks = {
        run = {
            command = "ruby %",
            output = "quickfix",
        },

        monitor = {
            command = "nodemon -e py %",
            output = "terminal",
        },

        debug = {
            command = "ruby -m pdb %",
            output = "terminal",
        },
    },
}
