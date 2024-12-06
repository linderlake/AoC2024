FROM mcr.microsoft.com/devcontainers/cpp:1-debian-11

ARG REINSTALL_CMAKE_VERSION_FROM_SOURCE="none"
ARG APT_PACKAGES="clang-format vim"
ARG VCPKG_PACKAGES="curlpp:x64-linux gtest:x64-linux"
ARG CLANGD_VERSION=17.0.3

# Optionally install the cmake for vcpkg
COPY ./reinstall-cmake.sh /tmp/

RUN if [ "${REINSTALL_CMAKE_VERSION_FROM_SOURCE}" != "none" ]; then \
        chmod +x /tmp/reinstall-cmake.sh && /tmp/reinstall-cmake.sh ${REINSTALL_CMAKE_VERSION_FROM_SOURCE}; \
    fi \
    && rm -f /tmp/reinstall-cmake.sh

RUN su vscode -c "${VCPKG_ROOT}/vcpkg install $VCPKG_PACKAGES"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends $APT_PACKAGES

# Add github.com to known hosts to avoid prompt
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Clone dotfiles
RUN cd ~ && git clone https://github.com/linderlake/dotfiles.git && cd dotfiles && ./setup.sh

# install clangd 17
RUN mkdir -p /tmp/ && \
    wget https://github.com/clangd/clangd/releases/download/${CLANGD_VERSION}/clangd-linux-${CLANGD_VERSION}.zip -P /tmp/ && \
    unzip /tmp/clangd* -d /tmp/ && \
    cp -R /tmp/clangd_${CLANGD_VERSION}/lib/* /usr/local/lib/ && \
    cp -R /tmp/clangd_${CLANGD_VERSION}/bin/* /usr/local/bin/ && \
    rm -rf /tmp/clangd*