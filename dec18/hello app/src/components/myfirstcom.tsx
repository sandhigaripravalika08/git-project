import React from 'react'

export default function 
() {
  return (
    <div>
        count login
        
	<div className="container h-100">
		<div className="d-flex justify-content-center h-100">
			<div className="user_card">
				<div className="d-flex justify-content-center">
					<div className="brand_logo_container">
						<img 
                        src="https://cdn.freebiesupply.com/logos/large/2x/pinterest-circle-logo-png-transparent.png"
                         className="brand_logo" 
                         alt="Logo"/>
					</div>
				</div>
				<div className="d-flex justify-content-center form_container">
					<form>
						<div className="input-group mb-3">
							<div className="input-group-append">
								<span className="input-group-text">
                                    <i className="fas fa-user"></i>
                             </span>
							</div>
							<input
                             type="text" 
                             name="username"
                             className="form-control input_user" 
                             placeholder="username"/>
						</div>
						<div className="input-group mb-2">
							<div className="input-group-append">
								<span className="input-group-text"><i className="fas fa-key"></i></span>
							</div>
							<input
                             type="password"
                              name="username" 
                              className="form-control input_pass"
                               value="" placeholder="password"/>
						</div>
						<div className="form-group">
							<div className="custom-control custom-checkbox">
								<input
                                 type="checkbox" 
                                 className="custom-control-input" 
                                 id="customControlInline"/>
								<label
                                 className="custom-control-label"
                                htmlFor="customControlInline"
                                 />
                                    Remember me
                                    
							</div>
						</div>
							<div className="d-flex justify-content-center mt-3 login_container">
				 	<button type="button" 
                    name="button" 
                    className="btn login_btn"
                    >Login</button>
				   </div>
					</form>
				</div>
		
				<div className="mt-4">
					<div className="d-flex justify-content-center links">
						Don't have an account? 
                        <a href="#" className="ml-2">
                            Sign Up</a>
					</div>
					<div className="d-flex justify-content-center links">
						<a href="#">
                            Forgot your password?</a>
					</div>
				</div>
			</div>
		</div>
	</div>

    </div>
  );
}
