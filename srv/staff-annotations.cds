annotate satinfotech.Staff with @(
    UI.LineItem          : [
        {
            Label: 'Staff ID',
            Value: staff_id
        },
        {
            Label: 'Staff Name',
            Value: staff_name
        },
        {
            Label: 'Staff Image',
            Value: staff_img
        },
        {
            Label: 'Designation',
            Value: staff_des
        },
        {
            Label: 'Salary',
            Value: staff_sal
        },
        {
            Label: 'Staff Age',
            Value: staff_age
        }
    ],
    UI.FieldGroup        : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: staff_id
            },
            {
                $Type: 'UI.DataField',
                Value: staff_name
            },
            {
                $Type: 'UI.DataField',
                Value: staff_img
            },
            {
                $Type: 'UI.DataField',
                Value: staff_des
            },
            {
                $Type: 'UI.DataField',
                Value: staff_sal
            },
            {
                $Type: 'UI.DataField',
                Value: staff_age
            }
        ],
    },
    UI.Facets           : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'StaffFacet',
            Label : 'Staff',
            Target: '@UI.FieldGroup',
        }
    ]
);
