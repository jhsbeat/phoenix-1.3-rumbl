import Player from "./player";

let Video = {
    init(socket, element) {
        if (!element) { return; }
        let youtubeId = element.getAttribute("data-youtube-id");
        let videoId = element.getAttribute("data-video-id");
        socket.connect();
        Player.init(element.id, youtubeId, () => {
            this.onReady(videoId, socket);
        });
    },
    onReady(videoId, socket) {
        let msgContainer = document.getElementById("msg-container");
        let msgInput = document.getElementById("msg-input");
        let postButton = document.getElementById("msg-submit");
        let vidChannel = socket.channel(`videos:${videoId}`);

        postButton.addEventListener("click", e => {
            let payload = {body: msgInput.value, at: Player.getCurrentTime()};
            vidChannel.push("new_annotation", payload)
                .receive("error", e => console.log(e));
            msgInput.value = "";
        });

        vidChannel.on("new_annotation", (resp) => {
            vidChannel.params.last_seen_id = resp.id;
            this.renderAnnotation(msgContainer, resp);
        });

        msgContainer.addEventListener("click", e => {
            e.preventDefault();
            let seconds = e.target.getAttribute("data-seek") ||
                e.target.parentNode.getAttribute("data-seek");
            if (!seconds) { return; }
            Player.seekTo(seconds);
        });

        vidChannel.join()
            .receive("ok", ({annotations}) => {
                let ids = annotations.map(ann => ann.id);
                if (ids.length > 0) { vidChannel.params.last_seen_id = Math.max(...ids); }
                this.scheduleMessages(msgContainer, annotations);
            })
            .receive("error", reason => console.log("join failed", reason));
    },
    esc(str) {
        let div = document.createElement("div");
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    },
    renderAnnotation(msgContainer, {user, body, at}) {
        let template = document.createElement("div");
        template.innerHTML = `
          <a href="#" data-seek="${this.esc(at)}">
            [${this.formatTime(at)}]
            <b>${this.esc(user.username)}</b>: ${this.esc(body)}
          </a>
        `;
        msgContainer.appendChild(template);
        msgContainer.scrollTop = msgContainer.scrollHeight;
    },
    scheduleMessages(msgContainer, annotations) {
        setTimeout(() => {
            let ctime = Player.getCurrentTime();
            let remaining = this.renderAtTime(annotations, ctime, msgContainer);
            this.scheduleMessages(msgContainer, remaining);
        }, 1000);
    },
    renderAtTime(annotations, seconds, msgContainer) {
        return annotations.filter(ann => {
            if (ann.at > seconds) {
                return true;
            } else {
                this.renderAnnotation(msgContainer, ann); // 진짜 말도 안되는 코드다... 아무리 phoenix 책이라서 js 는 대충이라지만...
                return false;
            }
        });
    },
    formatTime(at) {
        let date = new Date(null);
        date.setSeconds(at / 1000);
        return date.toISOString().substr(14, 5);
    }
};

export default Video;
