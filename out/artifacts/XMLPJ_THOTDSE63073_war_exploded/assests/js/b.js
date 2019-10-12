var MyUtils = {
  callXhr: function (method, url, params, callback) {
      var xhr = new XMLHttpRequest();
      xhr.open('POST', 'GeneralController?btnAction=SearchSim', true);
      xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
      xhr.onreadystatechange = function () {
          if (xhr.readyState == 4 && xhr.status == 200) {
              xmlDOM = xhr.responseXML;
          }
      }
      xhr.send();
      if (params != null) {
          xhr.send(params);
      } else {
          xhr.send();
      }
  },
  getFormData: function (formElem, obj) {
      let formData = new FormData();
      obj.forEach(function (item) {
          let selector;
          if (item.type == 'radio') {
              selector = formElem.querySelectorAll("input[name=" + item.name + "]:checked");
          }
          else {
              // text, hidden
              selector = formElem.querySelectorAll("input[name=" + item.name + "]");
          }
          formData.append(selector[0].name, selector[0].value);
      });

      return formData;
  },
  getFormParams: function (formElem, obj) {
      let params = '';
      let paramsArr = [];
      obj.forEach(function (item) {
          let selector;
          if (item.type == 'select') {
              selector = formElem.querySelectorAll("select[name=" + item.name + "]");
          } else if (item.type == 'radio') {
              selector = formElem.querySelectorAll("input[name=" + item.name + "]:checked");
          }
          else {
              // text, hidden
              selector = formElem.querySelectorAll("input[name=" + item.name + "]");
          }
          paramsArr.push(selector[0].name + '=' + selector[0].value);
      });
      params = paramsArr.join('&');
      console.log(params);
      return params;
  },
  getValueOfNodeDomByTagName: function(node, tagName) {
      if (node == null) return;

      let tag = node.getElementsByTagNameNS('*', tagName)[0];
      let value = null;
      if (tag != null) {
          value = tag.textContent;
      }
      return value;
  }
}




