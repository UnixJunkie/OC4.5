open Random
open Oc45

(* This is a file to test the functions of c45.ml*)

(* NOTE Warning! Random *MUST* be inited in the calling file. *)

let rec genUnifList nb = function
  | 0 -> []
  | len -> nb :: (genUnifList nb (len-1))

let nbCategories = 3 

let nbVal = 1000 (* for each category *)

let uncertainty = [|40; 1000; 400; 300; 1000; 400 ; 1000 |]

let featContinuity = [|true; true; true; true; true; true ; true |]

let canonCat1 = [|120; 6083; 3049; 734; 3052; 1363 ; 50|]
and canonCat2 = [|468; 1309; 3209; 590; 4029; 1095 ; 75 |]
and canonCat3 = [|58; 4968; 2798; 409; 4672; 1299 ; 35|]

let canon = [|canonCat1; canonCat2; canonCat3|]

let featureMax = [|550; 7500; 4000; 1200; 6000; 2000 ; 1500 |]

let nbFeatures = Array.length uncertainty

let genRandom () = 
  let set = ref [] in
  for cat = 1 to nbCategories do
    for count_val = 1 to nbVal do
      let data = Array.make nbFeatures (IntOc45.Continuous(0)) in 
      for feat = 0 to (nbFeatures - 1) do
        let canonVal = canon.(cat-1).(feat) in
        let rand = Random.int ( 2 * uncertainty.(feat)) in
        let value = canonVal + rand - uncertainty.(feat) in
        data.(feat) <- IntOc45.Continuous(value) ;
      done ;
      set := IntOc45.({ data = data ; category = cat - 1 }) :: !set ;
	  
    done ;
  done ;
  !set


let randTrainSet () = 
	IntOc45.addDataList (genRandom ())
		(IntOc45.emptyTrainSet nbFeatures nbCategories featContinuity)

let testData n = 
    let data = Array.make nbFeatures (IntOc45.Continuous(0)) in
    for feat = 0 to (nbFeatures - 1) do
        let rand = Random.int (2* uncertainty.(feat)) in
        data.(feat) <- IntOc45.Continuous(
			canon.(n).(feat) + rand - uncertainty.(feat));
    done ;
    data 
        
