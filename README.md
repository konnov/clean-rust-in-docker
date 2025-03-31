# Clean rust in docker

Sometimes, you need a clean throw-away Linux container to build a rust project.
Importantly, it's not a good idea to register container's ssh keys on GitHub.
Instead, we should use [ssh agent forwarding][fwd]. This small repository
contains exactly such a setup:

```sh
# Build a Docker image, start a container, and ssh into it.
# Type "crabcrab" when asked for a password.
./start.sh
```

[fwd]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/using-ssh-agent-forwarding
