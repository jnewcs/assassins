 function Switch(buttonID, containerID, aID, method, url) {
    var obj = this;
    this.button = document.getElementById(buttonID);
    this.container = document.getElementById(containerID);
    this.assassinID = aID;
    this.method = method;
    this.url = url;

    this.button.addEventListener("click", function(event){
        obj.query = obj.button.innerHTML;
        obj.performSwitch(event);
    });
}

Switch.prototype.performSwitch = function(event) {
    var obj = this;
    var myXHR = new XMLHttpRequest();

    myXHR.onreadystatechange = function() {
        if(this.readyState === 1) {
            NProgress.start(); 
        }
        if(this.readyState === 4) {
            if(this.responseText === "revive") {
                obj.button.innerHTML = "Revive";   
                obj.button.className = "action-button revive-button";
                obj.container.className = "assassin-card assassin-card-killed";
            } else {
                obj.button.innerHTML = "Assassinate"; 
                obj.button.className = "action-button kill-button";
                obj.container.className = "assassin-card assassin-card-active";
            }
            NProgress.done();  
            return;
        }
        if(this.status != 200) {
            return;
        }
    }
    myXHR.open(obj.method, obj.url+encodeURIComponent(obj.query) + "&id=" + encodeURIComponent(obj.assassinID), true);
    myXHR.send();
}