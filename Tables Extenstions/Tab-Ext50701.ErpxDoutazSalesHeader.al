tableextension 50701 ErpxDoutazSalesHeader extends "Sales Header"
{
    fields
    {
        field(50700; "Erpx Other Fees"; Decimal)
        {
            Caption = 'Other Fees HT';
            FieldClass = FlowField;
            CalcFormula = sum("ErpxDoutaz Other fees"."Amount HT" where("Document No." = field("No."), "Document Type" = field("Document Type")));
            Editable = false;
        }
        field(50701; "Erpx FA Statistics"; Boolean)
        {
            Caption = 'FA Statistics';
            DataClassification = ToBeClassified;
        }
        field(50702; "Erpx Fee Amount HT"; Decimal)
        {
            Caption = 'Fee Amount HT';
            DataClassification = ToBeClassified;
        }
        field(50703; "Erpx Overheads Desired Profit"; Decimal)
        {
            Caption = 'Overheads And Desired Profit HT';
            DataClassification = ToBeClassified;
        }
        field(50704; "Erpx Total Amount HT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount HT';            
        }
    }
}
