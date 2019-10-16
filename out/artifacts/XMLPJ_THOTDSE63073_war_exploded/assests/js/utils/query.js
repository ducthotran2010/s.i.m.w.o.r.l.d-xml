/* init XML HTTP in document */
try {
  if (window.XMLHttpRequest) {
    xhr = new XMLHttpRequest();
  } else if (window.ActiveXObject) {
    xhr = new ActiveXObject('Microsoft.XMLHTTP');
  }
} catch (error) {
  console.warn(error);
}

const query = ({ method, url, params, callback }) => {
  xhr.open(method, url, true);
  if (method === 'POST') {
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  }

  xhr.onreadystatechange = () => {
    if (xhr.readyState == 4 && xhr.status == 200) {
      callback(xhr.responseXML);
    }
  }

  if (params !== undefined && params !== null) {
    xhr.send(params);
  } else {
    xhr.send();
  }
};

const getLink = ({ phone, supplier }) => {
  switch (supplier) {
    case 'Sodepami':
      return `https://sodepami.vn/${phone}`;
  
    case 'Simsodep':
      return `https://simsodep.com/${phone}.html`;
  }
}



const getPhongThuyLink = (phone) => {
  const last4digit = phone.substring(6);
    return `phongthuy.jsp?phone=${last4digit}`;
}