page 50705 "Erpx doutaz Rate hours Line"
{
    Caption = 'Doutaz Rate hours Line';
    PageType = ListPart;
    SourceTable = "Erpx Doutaz Rate hours Line";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
