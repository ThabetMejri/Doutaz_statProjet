table 50705 "Erpx Doutaz Calc. Rate hours"
{
    Caption = 'Doutaz Calc. Rate hours';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Enum "Erpx Calc Rate Hours")
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 2 : 5;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
