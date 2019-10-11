const ParamResolver = {
  getParamsFromCheckbox({ name, checkbox }) {
    try {
      const checkedItems = [];
      checkbox.forEach(item => {
        if (item.checked) {
          checkedItems.push(`${name}=${item.value}`);
        }
      });

      return checkedItems.join('&');
    } catch (error) {
      console.warn(error);
    }

    return '';
  },

  getParamFromField({ name, field }) {
    try {
      if (field.value !== '') {
        return `${name}=${field.value}`
      }
    } catch (error) {
      console.warn(error);
    }
    return '';
  }
};