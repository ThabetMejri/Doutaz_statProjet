tableextension 50701 "ErpxDoutazSalesHeader" extends "Sales Header"
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
        field(50709; "Erpx Desired Benefit HT"; Decimal)
        {
            Caption = 'Desired Benefit HT';
            DataClassification = CustomerContent;
        }
        field(50710; "Erpx General Expenses Fees"; Decimal)
        {
            Caption = 'General Expenses Fees';
            FieldClass = FlowField;
            CalcFormula = lookup("Erpx Doutaz order Progress"."Amount HT" where("Document Type" = field("Document Type"), "No." = field("No."), Change = field("Erpx Last change")));
            Editable = false;
        }
        field(50711; "Erpx Last Change"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Erpx Doutaz order Progress".Change where("Document Type" = field("Document Type"), "No." = field("No.")));
            Editable = false;
        }
    }
}
