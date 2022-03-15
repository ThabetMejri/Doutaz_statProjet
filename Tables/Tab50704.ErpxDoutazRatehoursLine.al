table 50704 "Erpx Doutaz Rate hours Line"
{
    Caption = 'Doutaz Rate hours';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                SwSEmployee: Record "SwS Employee";
            begin
                if SwSEmployee.Get("Employee No.") then
                    "Full Name" := SwSEmployee.Name + ' ' + SwSEmployee."First Name"
                else
                    "Full Name" := '';
            end;
        }
        field(3; "Full Name"; Text[250])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Code; enum "Erpx Calc Rate Hours")
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';

        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Erpx Doutaz Calc. Rate hours".Description where(code = field(Code)));
            Editable = false;

        }
        field(6; Rate; Decimal)
        {
            Caption = 'Rate';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            trigger OnValidate()
            begin
                CalcAmount();
            end;
        }
        field(7; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcAmount();
            end;

        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Employee No.", Code)
        {
            Clustered = true;
        }
    }

    procedure CalcAmount()
    begin
        Amount := "Base Amount" * Rate / 100;

    end;
}
