page 50706 "ErpxDoutaz Calc Rate Hours"
{
    ApplicationArea = All;
    Caption = 'Doutaz Calc Rate Hours';
    PageType = List;
    SourceTable = "Erpx Doutaz Calc. Rate hours";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
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
            }
        }
    }
}
