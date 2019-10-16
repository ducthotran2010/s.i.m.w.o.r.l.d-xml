class View {
    constructor({inputId, tableId, errorMessageId, data}) {
        this.input = document.getElementById(inputId);
        this.table = document.getElementById(tableId);
        this.errorMessage = document.getElementById(errorMessageId);

        this.render({data});
    }

    getTableHead() {
        const thead = document.createElement('thead');
        const tr = document.createElement('tr');

        const ths = [
            document.createElement('th'),
            document.createElement('th'),
            document.createElement('th'),
        ];

        ths[0].innerHTML = 'Con Số';
        ths[1].innerHTML = 'Ý nghĩa chung của con số';
        ths[2].innerHTML = 'Mức độ tốt – xấu';

        ths.forEach(th => tr.appendChild(th));
        tr.setAttribute('class', 'home_tr home_tr--head');
        thead.appendChild(tr);

        return thead;
    }

    showError(isShowed) {
        if (isShowed === false) {
            this.errorMessage.classList.add('hidden');
        } else {
            this.errorMessage.classList.remove('hidden');
        }
    }

    render({data}) {
        if (data === undefined || (Array.isArray(data) && data.length === 0)) {
            this.showError(true);
            return;
        } else {
            this.showError(false);
        }
        ;

        this.table.innerHTML = '';
        const thead = this.getTableHead();
        this.table.appendChild(thead);

        const trs = data.map(({number, mean, brief}) => {
            const tr = document.createElement('tr');

            const tds = [];
            let td = document.createElement('td');
            let a = document.createElement('a');
            a.innerText = number;
            td.appendChild(a);
            tds.push(td);

            td = document.createElement('td');
            a = document.createElement('a');
            a.innerText = mean;
            td.appendChild(a);
            tds.push(td);

            td = document.createElement('td');
            a = document.createElement('a');
            a.innerText = brief;
            td.appendChild(a);
            tds.push(td);

            tds.forEach(td => tr.appendChild(td));
            tr.setAttribute('class', 'home_tr home_tr--body');
            return tr;
        });

        const tbody = document.createElement('tbody');
        trs.forEach(tr => tbody.appendChild(tr));
        this.table.appendChild(tbody);
        this.table.setAttribute('class', 'home_table')
    }
}

class Model {
    constructor({data}) {
        this.data = data;
    }
}

class Octopus {
    constructor() {
        this.view = new View({inputId: 'input', tableId: 'result', errorMessageId: 'error-message'});
        this.model = new Model({});

        this.view.input.addEventListener('keyup', this.handleSearch);
    }

    handleSearch = () => {
        const { data } = this.model;
        let text = this.view.input.value;

        if (text.length === 10 && text.match(/\d{10}/) !== null) {
            text = text.slice(6);
        }

        if (text.length === 4 && text.match(/\d{4}/) !== null && data !== undefined) {
            const value = parseInt(text);

            if (typeof value === 'number') {
                const a = value / 80;
                const b = a - Math.floor(a);
                const c = b * 80;
                const d = Math.round(c);

                const result = data.filter(({number}) => number == d);
                if (result.length > 0) {
                    this.view.render({data: result});
                    return;
                }
            }
        }

        this.view.render({data});
    }

    getDataFromDOM = (dom) => {
        const result = [];
        if (dom === null) {
            return result;
        }

        const Sections = dom.getElementsByTagName('Section');

        for (let i = 0; i < Sections.length; i++) {
            const section = Sections.item(i);
            const number = section.getElementsByTagName('Number')[0].innerHTML;
            const mean = section.getElementsByTagName('Mean')[0].innerHTML;
            const brief = section.getElementsByTagName('Brief')[0].innerHTML;
            result.push({number, mean, brief});
        }

        return result;
    }

    setModel = (newData) => {
        this.model = {
            ...this.model,
            ...newData
        };
    }

    getData({params}) {
        console.log(params);

        query({
            method: 'POST',
            url: constants.GENERAL_CONTROLLER,
            params,
            callback: (dom) => {
                const result = this.getDataFromDOM(dom);
                this.setModel({data: result});
                console.log(this.model.data)
                this.handleSearch();
            }
        })
    }
}

const octopus = new Octopus();
octopus.getData({params: 'btnAction=GetPhongThuy'});
octopus.handleSearch();