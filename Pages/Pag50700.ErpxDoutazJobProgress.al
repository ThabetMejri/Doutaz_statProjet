page 50700 "ErpxDoutazJobProgress"
{

    Caption = 'Job Progress';
    PageType = List;
    SourceTable = "Erpx Doutaz Job Progress";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Change; Rec.Change)
                {
                    ApplicationArea = All;
                    

                }
                field("% Overhead Rate"; Rec."% Overhead Rate")
                {
                    ApplicationArea = All;
                    
                }
                field("% Job Progress"; Rec."% Job Progress")
                {
                    ApplicationArea = All;
                    
                }

            }
        }
    }    

}
