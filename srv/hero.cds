using { com.hemanth.satinfotech as db } from '../db/schema';
using { API_PRODUCT_SRV as productapi} from './external/API_PRODUCT_SRV';

service satinfotech {
    entity Branch as projection on db.Branch;
    entity Staff as projection on db.Staff;

    entity Products as projection on productapi.A_Product {
        Product,
        ProductType,
        BaseUnit,
        ProductGroup,
        to_Description,
        null as ProductDescription: String(80)
    }

    entity ProductDescription as projection on productapi.A_ProductDescription {
        Product,
        Language,
        ProductDescription
    };

    entity Forms {
        key ID: UUID;
        FormName: String(80);
    }

    entity ProductLocal as projection on db.ProductLocal actions {
        action productData(
            State: String(80) @Common.Label: 'State',
            Forms: String(80) @Common.Label: 'Forms' @Common.ValueList: {
              CollectionPath: 'Forms', 
              Label: 'Label',
              Parameters: [
                {
                  $Type: 'Common.ValueListParameterInOut',
                  LocalDataProperty: 'Forms',  
                  ValueListProperty: 'FormName'    
                }
              ]
            }
        ) returns String;
    };
}

annotate satinfotech.Branch with @odata.draft.enabled;
annotate satinfotech.Staff with @odata.draft.enabled;
annotate satinfotech.ProductLocal with @odata.draft.enabled;

annotate satinfotech.Forms with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Value: 'ID'
    },
    {
        $Type: 'UI.DataField',
        Value: 'FormName'
    }
]);