return {
    tasks = {
        run = {
            command = "python %",
            output = "quickfix",
        },

        monitor = {
            command = "nodemon -e py %",
            output = "terminal",
        },

        debug = {
            command = "python -m pdb %",
            output = "terminal",
        },
    },
}
