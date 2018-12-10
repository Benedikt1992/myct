import argparse


class CLI:

    def __init__(self):
        pass

    def run(self):
        """
        Parse arguments and start selected command
        """
        parser = argparse.ArgumentParser(description="Create and control containers with the 'My Container Tool'.")
        subparsers = parser.add_subparsers(title='myct commands',
                                           # dest='command',
                                           metavar='COMMAND',
                                           help='Use COMMAND -h to get help for each command.')
        subparsers.required = True

        parser_init = subparsers.add_parser('init', help='Creates a container in the given directory')
        parser_init.add_argument('path', metavar='<container-path>')
        parser_init.set_defaults(func=self._init_command)

        parser_map = subparsers.add_parser('map',
                                            help='Mounts a host directory read-only into the container at given target')
        parser_map.add_argument('cpath', metavar='<container-path>')
        parser_map.add_argument('hpath', metavar='<host-path>')
        parser_map.add_argument('tpath', metavar='<target-path>')
        parser_map.set_defaults(func=self._map_command)

        parser_run = subparsers.add_parser('run', help='Runs the file exectuable in container with passed arguments')
        parser_run.add_argument('path', metavar='<container-path>')
        parser_run.add_argument('exec', metavar='<executable>')
        parser_run.add_argument('exec_args', metavar='args', nargs='*')
        parser_run.add_argument('--namespace', metavar='<kind>=<pid>', help='Join a namespace.')  # With 'type=' we could achieve automated splitting
        parser_run.add_argument('--limit', action='append', metavar='<controller.key>=<value>', help='Define limits. May repeat')  # With 'type=' we could achieve automated splitting
        parser_run.set_defaults(func=self._run_command)

        args, unknown = parser.parse_known_args()
        args.func(args, unknown)

    def _init_command(self, args, unknown):
        """
        Creates a container in the given directory (downloads and extracts root file system)
        $ myct init <container-path>
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Command init with path: " + str(args.path))

    def _map_command(self, args, unknown):
        """
        Mounts a host directory read-only into the container at given destination
        $ myct map <container-path> <host-path> <target-path>
        """
        if unknown:
            raise argparse.ArgumentTypeError("Detected unknown arguments: {!s}".format(str(unknown)))
        print("Command map with container {}, host path {} and target {}.".format(args.cpath, args.hpath, args.tpath))

    def _run_command(self, args, unknown):
        """
        Runs the file exectuable in container with passed arguments
        $ myct run <container-path> [options] <executable> [args...]
        with options being:
        --namespace <kind>=<pid>
        --limit <controller.key>=<value>
        """
        args.exec_args += unknown
        print("Command run with container {} and the executable {} with arguments {}.\nJoin namespace {} and set limits {}".format(
            args.path, args.exec, args.exec_args, args.namespace, args.limit))


def run():
    CLI().run()
