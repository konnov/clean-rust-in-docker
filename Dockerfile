FROM ubuntu:22.04

# Install dependencies
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN apt-get install -y openssh-server curl build-essential sudo tmux vim-nox zsh git wget libssl-dev pkg-config

# Create a user
RUN useradd -m rustdev && echo "rustdev:crabcrab" | chpasswd && adduser rustdev sudo
RUN chsh -s /usr/bin/zsh rustdev

# Enable agent forwarding, so we don't have to add the container keys on GH
RUN sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding yes/' /etc/ssh/sshd_config


# Install Oh My Zsh for rustdev
USER rustdev
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

# Optional: set a theme (e.g. "agnoster" or "robbyrussell")
RUN sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' ~/.zshrc

# Install Rust (via rustup)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y
ENV PATH="/home/rustdev/.cargo/bin:${PATH}"

# install reasonable vim settings
RUN mkdir -p ~/.vim/pack/tpope/start
RUN cd ~/.vim/pack/tpope/start && git clone https://tpope.io/vim/sensible.git

# always use ssh instead of https when cloning from github
RUN git config --global url."git@github.com:".insteadOf https://github.com/

# Back to root for final setup
USER root

# Set up SSH
RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
