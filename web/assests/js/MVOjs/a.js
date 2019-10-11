(function () {

    var Model = {
        guitars: [],
        currentPage: 0,
        selectedGuitar: null,
        paging: {
            numberOfPages: 0,
            pageSize: 10,
        },
        objForm: [{
            type: 'select',
            name: 'music-genre',
            required: true,
        },
            {
                type: 'select',
                name: 'body-style',
                required: true,
            },
            {
                type: 'select',
                name: 'price-level',
                required: true,
            },
            {
                type: 'select',
                name: 'origin',
                required: true,
            },
            {
                type: 'hidden',
                name: 'btAction',
                required: true,
            }],
        init: function () {
            this.currentPage = 0;
            this.paging.pageSize = 10;
        }
    };

    var HomeOctopus = {
        init: function () {
            Model.init();
            FormView.init();
            PagingView.init();
            ResultView.init();
            PopupView.init();
        },
        getSelectedGuitar: function () {
            return Model.selectedGuitar;
        },
        openPopup: function (guitar) {
            Model.selectedGuitar = guitar;
            PopupView.render();
        },
        closePopup: function () {
            Model.selectedGuitar = null;
            PopupView.render();
        },
        newAttribute(name, content) {
            let newAttr = {
                name: name,
                content: content
            }
            return newAttr;
        },
        newGuitar(id, name, category, price, imageUrl, weightedScore, attributes) {
            let newGuitar = {
                id: id,
                name: name,
                category: category,
                imageUrl: imageUrl,
                price: price,
                weightedScore: weightedScore,
                attributes: attributes
            }
            return newGuitar;
        },
        getGuitars: function () {
            return Model.guitars;
        },
        showLoader() {
            let loader = document.getElementById('loader');
            let currClass = loader.getAttribute('class');
            loader.setAttribute('class', currClass + ' loader-default is-active');
        },
        hideLoader() {
            let loader = document.getElementById('loader');
            loader.setAttribute('class', 'loader');
        },
        recommendGuitars: function (form) {
            // validation
            // show loader
            this.showLoader();
            let url = 'api/guitar/recommend'; // OLD: DispatchServlet
            let params = MyUtils.getFormParams(form, Model.objForm);
            var self = this;
            MyUtils.callXhr('POST', url, params, function (dom) {
                let guitars = self.parseGuitarFromDOM(dom);
                self.bindGuitarToModel(guitars);
                self.setNumberOfPages();
                Model.currentPage = 0;
                PagingView.render();
                ResultView.render();
                window.location.href = "#result";
                // hide loader
                self.hideLoader();
            });
        },
        parseGuitarFromDOM: function (dom) {
            let guitarDoms = dom.getElementsByTagName("guitar");
            let guitars = [];

            for (let i = 0; i < guitarDoms.length; i++) {
                let id = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'id');
                let guitarName = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'name');
                let category = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'category');
                let price = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'price');
                let imageUrl = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'imageUrl');
                let weightedScore = MyUtils.getValueOfNodeDomByTagName(guitarDoms[i], 'weightedScore');
                let attrDoms = guitarDoms[i].getElementsByTagNameNS('*', 'attribute');
                let attrs = [];
                for (let j = 0; j < attrDoms.length; j++) {
                    let attrName = MyUtils.getValueOfNodeDomByTagName(attrDoms[j], 'name');
                    let content = MyUtils.getValueOfNodeDomByTagName(attrDoms[j], 'content');
                    let attr = this.newAttribute(attrName, content);
                    attrs.push(attr);
                }

                let guitar = this.newGuitar(id, guitarName, category, price, imageUrl, weightedScore, attrs);
                guitars.push(guitar);
            }

            return guitars;
        },
        bindGuitarToModel: function (list) {
            Model.guitars = list;
        },
        createGuitarItem(guitar) {
            let wrapper = document.createElement('div');
            wrapper.setAttribute('class', 'item');
            wrapper.setAttribute('data-guitarid', guitar.id);

            let score = document.createElement('span');
            score.setAttribute('class', 'score');
            score.textContent = parseFloat(guitar.weightedScore).toPrecision(3);

            let imgCover = document.createElement('img');
            imgCover.setAttribute('src', guitar.imageUrl);

            let title = document.createElement('h2');
            title.setAttribute('class', 'item-title');
            title.textContent = guitar.name;

            let detail = document.createElement('div');
            detail.setAttribute('class', 'item-detail');

            let price = document.createElement('span');
            price.setAttribute('class', 'item-price');
            price.textContent = parseInt(guitar.price).toLocaleString('vi', { style: 'currency', currency: 'VND' });

            detail.append(price);

            wrapper.append(score, imgCover, title, detail);
            return wrapper;
        },
        setNumberOfPages: function () {
            let paging = Model.paging;
            paging.numberOfPages = Math.ceil(Model.guitars.length / paging.pageSize);
        },
        getNumberOfPages: function () {
            return Model.paging.numberOfPages;
        },
        setCurrentPage: function (index) {
            Model.currentPage = index;
            ResultView.render();
            PagingView.render();
        },
        getCurrentPage: function () {
            return Model.currentPage;
        },
        loadGuitarPerPage: function () {
            let guitarLength = Model.guitars.length;
            let index = Model.currentPage;
            let numPages = Model.paging.numberOfPages;
            let size = Model.paging.pageSize;
            let start = index * size;
            let end = start + size;
            let page = []; // guitar in a page
            if (index == numPages) { // LAST PAGE
                end = guitarLength;
            }
            page = Model.guitars.slice(start, end);
            return page;
        }
    }

    var FormView = {
        init: function () {
            this.searchForm = document.getElementById('filter-form');
            this.searchForm.addEventListener('submit', function (e) {
                e.preventDefault();
                HomeOctopus.recommendGuitars(this); // recommend recommend guitar with form
            });
            FormView.render();
        },
        render: function () {
            // RENDER FORM VIEW
        }
    }

    var ResultView = {
        init: function () {
            this.container = document.getElementById('guitar-container');
            this.emptyRow = document.getElementById('empty-row');
            ResultView.render();
        },
        render: function () {
            let $container = this.container;
            let $emptyRow = this.emptyRow;

            let guitars = HomeOctopus.loadGuitarPerPage();
            // CLEAR VIEW
            $emptyRow.innerHTML = '';
            $container.innerHTML = '';

            if (guitars != null && guitars.length > 0) {
                guitars.forEach(function (guitar) {
                    let item = HomeOctopus.createGuitarItem(guitar);
                    item.addEventListener('click', (function (copy) {
                        return function () {
                            HomeOctopus.openPopup(copy);
                        }
                    })(guitar));
                    $container.appendChild(item);
                });
            }
            else {
                let message = document.createElement('h1');
                message.setAttribute('class', 'empty-message');
                message.textContent = "Không có dữ liệu đàn guitar !";
                $emptyRow.appendChild(message);
            }
        }
    }

    var PagingView = {
        init: function () {
            this.paging = document.getElementById('guitar-paging');
        },
        render: function () {
            let $paging = this.paging;
            let numOfPages = HomeOctopus.getNumberOfPages();
            let currentPage = HomeOctopus.getCurrentPage();

            // CLEAR PAGING LIST
            $paging.innerHTML = '';

            for (let i = 0; i < numOfPages; i++) {
                let pageItem = document.createElement('a');
                pageItem.setAttribute('href', '#' + i);
                pageItem.textContent = i + 1;
                if (i == currentPage) {
                    pageItem.className += 'active';
                }

                pageItem.addEventListener('click', function (e) {
                    e.preventDefault();
                    HomeOctopus.setCurrentPage(i);
                    window.location.href = '#result';
                });
                $paging.appendChild(pageItem);
            }
        }
    }

    var PopupView = {
        init: function () {
            this.popup = document.getElementById('popup');
            this.closeButton = document.getElementById('popup-close');

            this.closeButton.addEventListener('click', function (e) {
                e.preventDefault();
                HomeOctopus.closePopup();
            });

            PopupView.render();
        },
        render: function () {
            let $popup = this.popup;
            let selectedGuitar = HomeOctopus.getSelectedGuitar();
            let photoDiv = $popup.getElementsByClassName('popup__photo')[0];
            let image = photoDiv.getElementsByTagName('img')[0];
            let title = $popup.getElementsByClassName('popup-title')[0];
            let price = $popup.getElementsByClassName('popup-price')[0];
            let attrTable = $popup.getElementsByClassName('popup-attribute')[0];


            if (selectedGuitar == null) { // CLOSE POPUP
                $popup.style.visibility = 'hidden';
                $popup.style.opacity = 0;
            } else { // OPEN POPUP
                console.log(selectedGuitar);
                // RESET ATTRIBUTE TABLE
                attrTable.innerHTML = '';

                // BIND DATA TO VIEW
                image.setAttribute('src', selectedGuitar.imageUrl);
                title.textContent = selectedGuitar.name;
                let score = document.createElement('span');
                score.setAttribute('class', 'popup-score');
                score.textContent = parseFloat(selectedGuitar.weightedScore).toPrecision(3);
                title.append(score);

                price.textContent = parseInt(selectedGuitar.price).toLocaleString('vi', { style: 'currency', currency: 'VND' });

                selectedGuitar.attributes.forEach(function (item) {
                    let row = document.createElement('tr');
                    let nameCol = '<td>' + item.name + '</td>';
                    let contentCol = '<td>' + item.content + '</td>';
                    row.innerHTML = nameCol + contentCol;
                    attrTable.appendChild(row);
                });

                // SET VISIBLE
                window.location.href = '#popup';
                $popup.style.visibility = 'visible';
                $popup.style.opacity = 1;
            }
        }
    }

    HomeOctopus.init();
})();
