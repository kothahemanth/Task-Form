annotate satinfotech.ProductLocal with @(
    UI.LineItem          : [
        {
            Label: 'Product',
            Value: Product
        },
        {
            Label: 'Product Type',
            Value: ProductType
        },
        {
            Label: 'Base Unit',
            Value: BaseUnit
        },
        {
            Label: 'Product Group',
            Value: ProductGroup
        },
        {
            Label: 'Product Description',
            Value: ProductDescription
        }
    ],
    UI.FieldGroup        : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Product
            },
            {
                $Type: 'UI.DataField',
                Value: ProductType
            },
            {
                $Type: 'UI.DataField',
                Value: BaseUnit
            },
            {
                $Type: 'UI.DataField',
                Value: ProductGroup
            },
            {
                $Type: 'UI.DataField',
                Value: ProductDescription
            },
        ],
    },
    UI.Facets           : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ProductLocalFacet',
            Label : 'ProductLocal',
            Target: '@UI.FieldGroup',
        }
    ]
);
