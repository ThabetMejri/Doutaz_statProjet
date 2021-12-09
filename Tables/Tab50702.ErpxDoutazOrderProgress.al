table 50702 "Erpx Doutaz Order Progress"
{
    Caption = 'Order Progress';
    DataClassification = ToBeClassified;
    LookupPageId = "Erpx Order Progress";
    DrillDownPageId = "Erpx Order Progress";
    fields
    {
        field(1001; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(1002; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
        }
        field(2; Change; Integer)
        {
            Caption = 'Change';
            DataClassification = ToBeClassified;
        }
        field(3; "% Overhead Rate"; Decimal)
        {
            Caption = '% Overhead Rate';
            DataClassification = ToBeClassified;
        }
        field(4; "% Job Progress"; Decimal)
        {
            Caption = '% Job Progress';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Amount HT"; Decimal)
        {
            Caption = 'Amount HT';
            DataClassification = ToBeClassified;
        }
        field(7; "Order Amount HT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Order Amount HT';
        }

    }
    keys
    {
        key(PK; "Document Type", "No.", "Job No.", Change)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;
  
}
