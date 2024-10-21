const cds = require('@sap/cds');
const json2xml = require('json2xml');
const axios = require('axios');

module.exports = cds.service.impl(async function(){
    const productapi = await cds.connect.to('API_PRODUCT_SRV');
    
    this.on('READ', 'Products', async req => {
        req.query.SELECT.columns = [
            { ref: ['Product'] },
            { ref: ['ProductType'] },
            { ref: ['ProductGroup'] },
            { ref: ['BaseUnit'] },
            { ref: ['to_Description'], expand: ['*'] }
        ];
        
        let res = await productapi.run(req.query);  

        res.forEach((element) => {
            element.to_Description.forEach((item) => {
                if (item.Language === 'EN') {
                    element.ProductDescription = item.ProductDescription;
                }
            });
        });
        
        return res;
    });

    this.before('READ', 'ProductLocal', async req => {
        const { Products, ProductLocal } = this.entities;
        const qry = SELECT.from(Products)
            .columns([{ ref: ['Product'] }, { ref: ['ProductType'] }, { ref: ['ProductGroup'] }, { ref: ['BaseUnit'] }, { ref: ['to_Description'], expand: ['*'] }])
            .limit(1000);

        let res = await productapi.run(qry);
        
        res.forEach((element) => {
            element.to_Description.forEach((item) => {
                if (item.Language === 'EN') {
                    element.ProductDescription = item.ProductDescription;
                }
            });
            delete(element.to_Description);
        });

        const insqry = UPSERT.into(ProductLocal).entries(res);
        await cds.run(insqry);        
    });

    this.before('UPDATE', 'ProductLocal', async req => {
        const { ProductDescription } = this.entities;
        const { ProductDescription: description, Product } = req.data;

        const updqry = UPDATE(ProductDescription).data({ "ProductDescription": description })
            .where({ Product, Language: 'EN' });
        await productapi.run(updqry);
    });

    this.before('CREATE', 'ProductLocal', async req => {
        const { Products } = this.entities;
        const { Product, ProductType, BaseUnit, ProductDescription } = req.data;

        const insqry = INSERT.into(Products).entries({
            "Product": Product,
            "ProductType": ProductType,
            "BaseUnit": BaseUnit,
            "to_Description": [
                {
                    "Product": Product,
                    "Language": "EN",
                    "ProductDescription": ProductDescription
                }
            ]
        });

        await productapi.run(insqry);
    });

    this.on('READ', 'Forms', async (req) => {
            const form = [
                { "FormName": "hemanth/Default" },
                { "FormName": "sumanth/Default" },
                { "FormName": "annapurna/Default" },
            ];
            form.$count = form.length;
            return form;
        });

    this.on('productData', 'ProductLocal', async (req) => {
        const { Product } = req.params[0];  
        console.log(req.data);
        const rowData = await SELECT.one.from(this.entities.ProductLocal).where({ Product });

        if (!rowData) {
            return req.error(404, `No data found for Product: ${Product}`);
        }

        rowData.State = req.data.State;  
        let forn = req.data.Forms;

        console.log("Row data with State and Forms:", rowData);

        const xmlfun = (rowData) => {
            const xmlData = json2xml({ Product: rowData }, { header: true });
            return xmlData;
        };

        const callxml = xmlfun(rowData);

        console.log("Generated XML:", callxml);
        const base64EncodedXML = Buffer.from(callxml).toString('base64');

        try {
            const authResponse = await axios.get('https://chembonddev.authentication.us10.hana.ondemand.com/oauth/token', {
                params: { grant_type: 'client_credentials' },
                auth: {
                    username: 'sb-ffaa3ab1-4f00-428b-be0a-1ec55011116b!b142994|ads-xsappname!b65488',
                    password: 'e44adb92-4284-4c5f-8d41-66f8c1125bc5$F4bN1ypCgWzc8CsnjwOfT157HCu5WL0JVwHuiuwHcSc='
                }
            });

            const accessToken = authResponse.data.access_token;

            const pdfResponse = await axios.post('https://adsrestapi-formsprocessing.cfapps.us10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName', {
                xdpTemplate: forn,
                xmlData: base64EncodedXML,
                formType: "print",
                formLocale: "",
                taggedPdf: 1,
                embedFont: 0
            }, {
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    'Content-Type': 'application/json'
                }
            });

            const fileContent = pdfResponse.data.fileContent;
            console.log("File Content:",fileContent);
            return fileContent;

        } catch (error) {
            console.error("Error occurred:", error);
            return req.error(500, "An error occurred while processing your request.");
        }
    });
});
