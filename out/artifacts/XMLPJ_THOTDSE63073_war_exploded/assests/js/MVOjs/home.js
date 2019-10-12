
const INIT_OFFSET = 0;
const SIZE = 50;

class Model {
  constructor() {
    this.offset = INIT_OFFSET;
  }
}

class View {
  constructor(id) {
    this.form = document.getElementById(id);
    this.render();
  }
  render() { }
}

class Octopus {
  constructor(model, view) {
    this.model = model;
    this.view = view;

    this.view.form.addEventListener('submit', event => {
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
    });
  }

  searchSim({ params }) {
    console.log(params);
    
    query({ 
      method: 'POST',
      url: constants.GENERAL_CONTROLLER,
      params,
      callback: (dom) => {
        /* do things on view */
        console.log(dom);
      }
     });
  }

}

const model = new Model();
const view = new View('search-form');
const octopus = new Octopus(model, view);
