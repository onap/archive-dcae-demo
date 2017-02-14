export JAVA_HOME=/opt/app/java/jdk/jdk170
export GROOVY_HOME=/opt/app/groovy/246

PATH=$JAVA_HOME/bin:$GROOVY_HOME/bin:$PATH

: ${USER:=root}
PS1="${USER}@`hostname` \!:: "
alias ll='ls -lrt'
alias hi='history 100'
alias rm='rm -i'
bind '"\C-p": history-search-backward' '"\C-n": history-search-forward'

cd /opt/app/*server

export ZONE=$(grep ZONE /opt/app/dcae-controller/config.yaml | sed s/ZONE:.//)
