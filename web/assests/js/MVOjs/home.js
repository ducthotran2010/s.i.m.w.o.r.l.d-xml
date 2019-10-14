
const INIT_OFFSET = 0;
const SIZE = 13;

class Model {
  constructor() {
    this.offset = INIT_OFFSET;
    this.isLoading = false;
    this.result = null;
    this.totalPage = 0;
    this.currentPage = 1;
  }
}

class View {
  constructor({
    loaderId,
    formId,
    resultId,
    resultMessageId,
    resultDetailId,
    paginationLeftId,
    paginationRightId,
    paginationInputId,
    paginationFormId,
    paginationMessageId,
    paginationContainerId,
  }) {
    this.form = document.getElementById(formId);
    this.loader = document.getElementById(loaderId);
    this.result = document.getElementById(resultId);
    this.resultMessage = document.getElementById(resultMessageId);
    this.resultDetail = document.getElementById(resultDetailId);
    this.paginationLeft = document.getElementById(paginationLeftId);
    this.paginationRight = document.getElementById(paginationRightId);
    this.paginationInput = document.getElementById(paginationInputId);
    this.paginationForm = document.getElementById(paginationFormId);
    this.paginationMessage = document.getElementById(paginationMessageId);
    this.paginationContainer = document.getElementById(paginationContainerId);
    this.render();
  }

  render() { }

  getTableHeadOfResultDetail() {
    const thead = document.createElement('thead');
    const tr = document.createElement('tr');

    const ths = [
      document.createElement('th'),
      document.createElement('th'),
      document.createElement('th'),
      document.createElement('th'),
      document.createElement('th'),
    ];

    ths[0].innerHTML = 'STT';
    ths[1].innerHTML = 'Sim số đẹp';
    ths[2].innerHTML = 'Giá bán';
    ths[3].innerHTML = 'Nhà mạng';
    ths[4].innerHTML = 'Nhãn';

    ths.forEach(th => tr.appendChild(th));
    tr.setAttribute('class', 'home_tr home_tr--head');
    thead.appendChild(tr);

    return thead;
  }

  renderResultDetail({ dom, result, offset }) {
    const table = document.createElement('table');
    const thead = this.getTableHeadOfResultDetail();
    table.appendChild(thead);

    const trs = result.map(({ phoneNumber, price, networkOperator, tag, supplier }, index) => {
      const tr = document.createElement('tr');

      const href = getLink({ phone: phoneNumber.replace(/\./g,''), supplier})
      const tds = [];
      let td = document.createElement('td');
      let a = document.createElement('a');
      a.setAttribute('href', href);
      a.innerHTML = offset + index + 1;
      td.appendChild(a);
      tds.push(td);

      td = document.createElement('td');
      a = document.createElement('a');
      a.setAttribute('href', href);
      a.innerHTML = phoneNumber;
      td.appendChild(a);
      tds.push(td);

      td = document.createElement('td');
      a = document.createElement('a');
      a.setAttribute('href', href);
      a.innerHTML = price.toLocaleString() + ' đ';
      td.appendChild(a);
      tds.push(td);

      td = document.createElement('td');
      a = document.createElement('a');
      a.setAttribute('href', href);
      a.innerHTML = networkOperator;
      td.appendChild(a);
      tds.push(td);

      td = document.createElement('td');
      a = document.createElement('a');
      a.setAttribute('href', href);
      a.innerHTML = tag;
      td.appendChild(a);
      tds.push(td);

      tds.forEach(td => tr.appendChild(td));
      tr.setAttribute('class', 'home_tr home_tr--body');
      return tr;
    });

    const tbody = document.createElement('tbody');
    trs.forEach(tr => tbody.appendChild(tr));
    table.appendChild(tbody);
    table.setAttribute('class', 'home_table')

    this.resultDetail.innerHTML = '';
    this.resultDetail.appendChild(table);
  }
}

class Octopus {
  constructor() {
    this.model = new Model();
    this.view = new View({
      formId: 'search-form',
      loaderId: 'loader',
      resultId: 'result-view',
      resultMessageId: 'result-message',
      resultDetailId: 'result-detail',
      paginationLeftId: 'pagination-left',
      paginationRightId: 'pagination-right',
      paginationInputId: 'pagination-input',
      paginationFormId: 'pagination-form',
      paginationMessageId: 'pagination-infor',
      paginationContainerId: 'pagination-container',
    });

    this.view.form.addEventListener('submit', this.handleSubmitForm);
    this.view.paginationLeft.addEventListener('click', this.handlePaginationLeft);
    this.view.paginationRight.addEventListener('click', this.handlePaginationRight);
    this.view.paginationInput.addEventListener('keypress', this.handlePaginationInput);
    this.view.paginationForm.addEventListener('submit', this.handlePaginationSubmit);
  }

  handlePaginationInput = () => {
    this.view.paginationLeft.disabled = true;
    this.view.paginationRight.disabled = true;
  }

  handlePaginationSubmit = (event) => {
    event.preventDefault();
    const nextPage = this.view.paginationInput.value;
    const offset = (nextPage - 1) * SIZE;
    if (1 <= nextPage && nextPage <= this.model.totalPage) {
      this.setModel({ offset, currentPage: nextPage });
      this.view.paginationInput.value = nextPage;
      this.checkPagination();
    }
  }

  handlePaginationLeft = () => {
    const nextPage = this.model.currentPage - 1;
    const offset = (nextPage - 1) * SIZE;
    if (1 <= nextPage && nextPage <= this.model.totalPage) {
      this.setModel({ offset, currentPage: nextPage });
      this.view.paginationInput.value = nextPage;
      this.checkPagination();
    }
  }

  handlePaginationRight = () => {
    const nextPage = this.model.currentPage + 1;
    const offset = (nextPage - 1) * SIZE;
    if (1 <= nextPage && nextPage <= this.model.totalPage) {
      this.setModel({ offset, currentPage: nextPage });
      this.view.paginationInput.value = nextPage;
      this.checkPagination();
    }
  }

  checkPagination = () => {
    const { currentPage, totalPage } = this.model;
    this.view.paginationLeft.disabled = false;
    this.view.paginationRight.disabled = false;

    if (currentPage <= 1) {
      this.view.paginationLeft.disabled = true;
    }
    if (currentPage >= totalPage) {
      this.view.paginationRight.disabled = true;
    }
    this.updateViewResult();
  }

  handleSubmitForm = (event) => {
    event.preventDefault();
    const { btnAction, startWith, notInclude, networkOperator, phone, priceLimit } = event.target.elements;

    const paramList = [
      ParamResolver.getParamFromField({ name: 'btnAction', field: btnAction }),
      ParamResolver.getParamFromField({ name: 'phone', field: phone }),
      ParamResolver.getParamFromField({ name: 'priceLimit', field: priceLimit }),
      ParamResolver.getParamsFromCheckbox({ checkbox: startWith, name: 'startWith' }),
      ParamResolver.getParamsFromCheckbox({ checkbox: notInclude, name: 'notInclude' }),
      ParamResolver.getParamsFromCheckbox({ checkbox: networkOperator, name: 'networkOperator' })
    ];
    const params = paramList.filter(param => param.length !== 0).join('&');

    this.searchSim({ params });
  }



  setModel(modelState) {
    this.model = {
      ...this.model,
      ...modelState,
    };
  }

  searchSim({ params }) {
    console.log(params);

    this.setModel({ isLoading: true });
    this.updateViews();

    query({
      method: 'POST',
      url: constants.GENERAL_CONTROLLER,
      params,
      callback: (dom) => {
        const result = this.getDataFromDOM(dom);
        this.setModel({
          isLoading: false,
          result,
          totalPage: parseInt((result.length + SIZE - 1) / SIZE, 10)
        });
        this.updateViews();
      }
    });
  }

  getDataFromDOM(dom) {
    const result = [];
    if (dom === null) {
      return result;
    }

    const SimWorld = dom.getElementsByTagName('Sim');

    for (let i = 0; i < SimWorld.length; i++) {
      const sim = SimWorld.item(i);
      let phoneNumber = sim.getElementsByTagName('PhoneNumber')[0].innerHTML;
      phoneNumber = phoneNumber.slice(0,3) + "." + phoneNumber.slice(3, 7) + "." + phoneNumber.slice(7);
      const price = sim.getElementsByTagName('Price')[0].innerHTML;
      const networkOperator = sim.getElementsByTagName('NetworkOperator')[0].innerHTML;
      const tag = sim.getElementsByTagName('Tag')[0] !== undefined ? sim.getElementsByTagName('Tag')[0].innerHTML : 'Số Đẹp';
      const supplier = sim.getElementsByTagName('Supplier')[0].innerHTML;

      result.push({
        phoneNumber,
        price: parseFloat(price, 10) * 1000,
        networkOperator,
        tag,
        supplier,
      })
    }

    return result;
  }

  updateViewLoader() {
    const { isLoading } = this.model;

    let classValue = this.view.loader.className;
    if (!isLoading) {
      if (!classValue.includes('hidden')) {
        classValue = `${classValue} hidden`;
      }
    } else if (classValue.includes('hidden')) {
      classValue = classValue.substring(0, classValue.length - 'hidden'.length - 1);
    }

    this.view.loader.setAttribute('class', classValue);
  }

  updateViewResult() {
    const { isLoading, totalPage } = this.model;

    /**
     * Update class name
     */
    let classValue = this.view.result.className;
    if (isLoading) {
      if (!classValue.includes('hidden')) {
        classValue = `${classValue} hidden`;
      }
    } else if (classValue.includes('hidden')) {
      classValue = classValue.substring(0, classValue.length - 'hidden'.length - 1);
    }
    this.view.result.setAttribute('class', classValue);

    if (!isLoading) {
      if (totalPage === 0) {
        this.view.resultMessage.innerHTML = 'Không có dữ liệu';
        this.view.resultDetail.innerHTML = '';
      }
      else {
        const { result, offset } = this.model;
        this.view.resultMessage.innerHTML = '';
        this.view.renderResultDetail({ result: result.slice(offset, offset + SIZE), offset });
      }
    }
  }

  updateViewPagination() {
    const { totalPage } = this.model;

    if (totalPage === 0) {
      this.view.paginationContainer.className = "hidden"
      /* hide */
    } else {
      const currentPage = 1;
      this.setModel({ currentPage, offset: 0 });
      this.view.paginationContainer.className = "";
      this.view.paginationInput.value = currentPage;
      this.view.paginationInput.setAttribute('max', totalPage);
      this.view.paginationMessage.innerHTML = `/ ${totalPage} trang`
      this.checkPagination();
    }
  }

  updateViews() {
    this.updateViewLoader();
    this.updateViewResult();
    this.updateViewPagination();
  }
}

const octopus = new Octopus();
octopus.searchSim({ params: 'btnAction=SearchSim' });
