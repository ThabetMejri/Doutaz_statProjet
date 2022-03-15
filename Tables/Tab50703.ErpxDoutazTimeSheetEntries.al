table 50703 "Erpx Doutaz TimeSheet Entries"
{
    Caption = 'Doutaz TimeSheet Entries';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
        }
        field(2; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(3; "Resouce Name"; Text[100])
        {
            Caption = 'Resouce Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Resource No.")));
            Editable = false;
        }
        field(4; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(5; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
