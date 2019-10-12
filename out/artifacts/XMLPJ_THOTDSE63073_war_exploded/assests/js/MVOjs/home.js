
const INIT_OFFSET = 0;
const SIZE = 50;

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
    this.paginationLeft = document.getElementById(paginationLeftId);
    this.paginationRight = document.getElementById(paginationRightId);
    this.paginationInput = document.getElementById(paginationInputId);
    this.paginationForm= document.getElementById(paginationFormId);
    this.paginationMessage = document.getElementById(paginationMessageId);
    this.paginationContainer = document.getElementById(paginationContainerId);
    this.render();
  }
  render() { }
}

class Octopus {
  constructor() {
    this.model = new Model();
    this.view = new View({
      formId: 'search-form',
      loaderId: 'loader',
      resultId: 'result-view',
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
      const PhoneNumber = sim.getElementsByTagName('PhoneNumber')[0].innerHTML;
      const Price = sim.getElementsByTagName('Price')[0].innerHTML;
      const NetworkOperator = sim.getElementsByTagName('NetworkOperator')[0].innerHTML;
      const Tag = sim.getElementsByTagName('Tag')[0].innerHTML;

      result.push({
        PhoneNumber,
        Price,
        NetworkOperator,
        Tag,
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
    const { isLoading } = this.model;

    let classValue = this.view.result.className;
    if (isLoading) {
      if (!classValue.includes('hidden')) {
        classValue = `${classValue} hidden`;
      }
    } else if (classValue.includes('hidden')) {
      classValue = classValue.substring(0, classValue.length - 'hidden'.length - 1);
    }

    this.view.result.setAttribute('class', classValue);

    console.log("------");
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
      this.view.paginationMessage.innerHTML = `of ${totalPage} pages`
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
