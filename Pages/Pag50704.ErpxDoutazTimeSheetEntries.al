page 50704 "Erpx Doutaz TimeSheet Entries"
{
    ApplicationArea = All;
    Caption = 'Doutaz TimeSheet Entries';
    PageType = List;
    SourceTable = "Erpx Doutaz TimeSheet Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Resouce Name"; Rec."Resouce Name")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
