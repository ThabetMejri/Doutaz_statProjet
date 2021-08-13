tableextension 50700 ErpxDoutazJob extends Job
{
    fields
    {
        field(50700; "Erpx % General Expenses Fees"; Decimal)
        {
            Caption = '% General Expenses Fees';
            FieldClass = FlowField;
            CalcFormula = lookup(ErpxDoutazJobProgress."% Overhead Rate" where("Job No." = field("No."), Change = field("Erpx Last Progress")));
            Editable = false;
        }
        field(50701; "Erpx % Desired Benefit"; Decimal)
        {
            Caption = '% Desired Benefit ';
            DataClassification = CustomerContent;
        }
        field(50702; "Erpx Average Fees"; Decimal)
        {
            Caption = 'Average Fees';
            DataClassification = CustomerContent;
        }
        field(50703; "Erpx Fees HT at Disposal"; Decimal)
        {
            Caption = 'Fees HT at Disposal';
            DataClassification = CustomerContent;
        }
        field(50704; "Erpx Fees HT Used"; Decimal)
        {
            Caption = 'Fees HT Used';
            DataClassification = CustomerContent;
        }
        field(50705; "Erpx Fees HT Balance Available"; Decimal)
        {
            Caption = 'Fees HT Balance Available';
            DataClassification = CustomerContent;
        }
        field(50706; "Erpx Hour fees Bal. Disposal"; Decimal)
        {
            Caption = 'Hourly fees Balance at Disposal';
            DataClassification = CustomerContent;
        }
        field(50707; "Erpx Hourly Fees Available"; Decimal)
        {
            Caption = 'Hourly Fees Available';
            DataClassification = CustomerContent;
        }
        field(50708; "Erpx Hourly Fees Used"; Decimal)
        {
            Caption = 'Hourly Fees Used';
            DataClassification = CustomerContent;
        }
        field(50709; "Erpx Desired Benefit HT"; Decimal)
        {
            Caption = 'Desired Benefit HT';
            DataClassification = CustomerContent;
        }
        field(50710; "Erpx Risk and Chance HT"; Decimal)
        {
            Caption = 'Risk and Chance HT';
            DataClassification = CustomerContent;
        }
        field(50711; "Erpx Benefit Forecast"; Decimal)
        {
            Caption = 'Benefit Forecast';
            DataClassification = CustomerContent;
        }
        field(50712; "Erpx Last Progress"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max(ErpxDoutazJobProgress.Change where("Job No." = field("No.")));
            Editable = false;
        }
        field(50713; "Erpx Fee Amount HT"; Decimal)
        {
            Caption = 'Fee Amount HT';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Header"."Erpx Fee Amount HT" where("ErpX Job No." = field("No.")));
            Editable = false;
        }
        field(50714; "Erpx Overheads Desired Profit"; Decimal)
        {
            Caption = 'Overheads And Desired Profit';
            CalcFormula = sum("Sales Header"."Erpx Overheads Desired Profit" where("ErpX Job No." = field("No.")));
            FieldClass = FlowField;
            Editable = false;
        }

    }
}
