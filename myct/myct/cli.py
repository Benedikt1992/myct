import argparse


class CLI:

    def __init__(self):
        pass

    def run(self):
        """
        Parse arguments and start selected mode
        """
        parser = argparse.ArgumentParser(description="Create and control containers with the 'My Container Tool'.")
        # parser.add_argument('mode',
        #                     help='an integer for the accumulator')
        # parser.add_argument('init', metavar='N', type=int, nargs='+',
        #                     help='an integer for the accumulator')
        # parser.add_argument('--sum', dest='accumulate', action='store_const',
        #                     const=sum, default=max,
        #                     help='sum the integers (default: find the max)')
        subparsers = parser.add_subparsers(title='mode',
                                           # dest='mode',
                                           metavar='MODE',
                                           help='Use MODE -h to get help for each mode.')
        subparsers.required = True

        parser_init = subparsers.add_parser('init', help='Creates a container in the given directory')
        parser_init.add_argument('path', metavar='<container-path>')
        parser_init.set_defaults(func=self._mode_init)

        parser_init = subparsers.add_parser('map',
                                            help='Mounts a host directory read-only into the container at given target')
        parser_init.add_argument('cpath', metavar='<container-path>')
        parser_init.add_argument('hpath', metavar='<host-path>')
        parser_init.add_argument('tpath', metavar='<target-path>')
        parser_init.set_defaults(func=self._mode_map)

        parser_init = subparsers.add_parser('run', help='Runs the file exectuable in container with passed arguments')
        parser_init.add_argument('path', metavar='<container-path>')
        parser_init.add_argument('exec', metavar='<executable>')
        parser_init.add_argument('exec_args', metavar='args', nargs='*')
        parser_init.set_defaults(func=self._mode_run)


        # myct
        # run < container - path > [options] < executable > [args...]
        # with options being:
        #     --namespace < kind >= < pid >
        # --limit < controller.key >= < value >
        #
        args, unknown = parser.parse_known_args()
        args.func(args, unknown)

    def _mode_init(self, args, unknown):
        """
        Creates a container in the given directory (downloads and extracts root file system)
        $ myct init <container-path>
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Mode init with path: " + str(args.path))

    def _mode_map(self, args, unknown):
        """
        Mounts a host directory read-only into the container at given destination
        $ myct map <container-path> <host-path> <target-path>
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Mode map with container {}, host path {} and target {}.".format(args.cpath, args.hpath, args.tpath))

    def _mode_run(self, args, unknown):
        """
        Runs the file exectuable in container with passed arguments
        $ myct run <container-path> [options] <executable> [args...]
        with options being:
        --namespace <kind>=<pid>
        --limit <controller.key>=<value>
        """
        args.exec_args += unknown
        print("Mode run with container {} and the executable {} with arguments {}.".format(args.path, args.exec, args.exec_args))

def run():
    CLI().run()
