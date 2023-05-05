<%-- 
    Document   : creaCad
    Created on : 19-nov-2020, 11.37.24
    Author     : rcosco
--%>
<form id="kt_form" action="<%=request.getContextPath()%>/OperazioniCi?type=creaCad" class="kt-form kt-form--label-right" accept-charset="ISO-8859-1" method="post">
    <div class="kt-portlet__body paddig_0_t paddig_0_b">
        <div class="kt-section kt-section--first">
            <div class="kt-section__body"><br>
                <h5>Dati personali:</h5>
                <div class="kt-separator kt-separator--border kt-separator--space-sm"></div>
                <div class="row form-group">
                    <div class="col-lg-3 col-md-6">
                        <label>Nome</label><label class="kt-font-danger">*</label>
                        <input class="form-control obbligatory" name="nome">
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <label>Cognome</label><label class="kt-font-danger">*</label>
                        <input class="form-control obbligatory" name="cognome">
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <label>Numero</label><label class="kt-font-danger">*</label>
                        <input class="form-control obbligatory" name="numero" onkeypress="return isNumber(event);">
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <label>Email</label><label class="kt-font-danger">*</label>
                        <input class="form-control obbligatory" name="email" id="email">
                    </div>
                </div>
                <h5>Data e ora colloquio:</h5>
                <div class="kt-separator kt-separator--border kt-separator--space-sm"></div>
                <div class="row form-group">
                    <div class="col-lg-3 col-md-6">
                        <label>Data</label><label class="kt-font-danger">*</label>
                        <input type="text" class="form-control obbligatory" name="giorno" id="giorno"  autocomplete="off" readonly placeholder="Selezionare giorno del colloquio">
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <label>ora di inizio e fine</label><label class="kt-font-danger">*</label>
                        <div class="input-group" >
                            <div class="col-6" style="padding-left: 0px; ">
                                <input type="text" class="form-control time obbligatory" disabled name="start" id="start" placeholder="Orario inizio" autocomplete="off" readonly/>
                            </div>
                            <div class="col-6" style="padding-right: 0px;">
                                <input type="text" class="form-control time obbligatory" disabled name="end" id="end" placeholder="Orario fine" autocomplete="off" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6">
                        <div id="impegni">
                        </div>
                    </div>
                </div>
            </div>
            <label class="kt-font-danger kt-font-bold"><font size="2" >* Campi Obbligatori</font></label>
            <div class="kt-portlet__foot">
                <div class="kt-form__actions">
                    <div class="row">
                        <div class="offset-6 col-6 kt-align-right">
                            <a id="submit" href="javascript:void(0);" class="btn btn-io"><font color='white'>Salva</font></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>